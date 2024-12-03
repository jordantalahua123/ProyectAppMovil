import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../models/recurso_educativo_model.dart';
import '../../services/recurso_educativo_service.dart';

class AgregarEditarRecursoView extends StatefulWidget {
  final RecursoEducativo? recurso;

  AgregarEditarRecursoView({this.recurso});

  @override
  _AgregarEditarRecursoViewState createState() => _AgregarEditarRecursoViewState();
}

class _AgregarEditarRecursoViewState extends State<AgregarEditarRecursoView> {
  final _formKey = GlobalKey<FormState>();
  final _recursoService = RecursoEducativoService();
  final ImagePicker _picker = ImagePicker();

  late TextEditingController _descripcionController;
  File? _selectedFile;
  String _tipoRecurso = 'imagen';
  VideoPlayerController? _videoPlayerController;

  @override
  void initState() {
    super.initState();
    _descripcionController = TextEditingController(text: widget.recurso?.descripcion ?? '');
    if (widget.recurso != null) {
      _tipoRecurso = widget.recurso!.tipo;
      if (_tipoRecurso == 'video') {
        _initializeVideoPlayer(widget.recurso!.url);
      }
    }
  }

  Future<void> _requestPermissions() async {
    await Permission.photos.request();
    await Permission.camera.request();
    await Permission.storage.request();
  }

  void _initializeVideoPlayer(String url) {
    _videoPlayerController = VideoPlayerController.network(url)
      ..initialize().then((_) {
        setState(() {});
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.recurso == null ? 'Agregar Recurso' : 'Editar Recurso'),
        backgroundColor: Colors.lightGreen,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              TextFormField(
                controller: _descripcionController,
                decoration: InputDecoration(labelText: 'Descripción'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese una descripción';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              DropdownButtonFormField<String>(
                value: _tipoRecurso,
                decoration: InputDecoration(labelText: 'Tipo de Recurso'),
                items: ['imagen', 'video'].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value.capitalize()),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _tipoRecurso = newValue!;
                    _selectedFile = null;
                    if (_videoPlayerController != null) {
                      _videoPlayerController!.dispose();
                      _videoPlayerController = null;
                    }
                  });
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _pickFile,
                child: Text('Seleccionar ${_tipoRecurso.capitalize()}'),
              ),
              SizedBox(height: 20),
              if (_selectedFile != null)
                _buildPreview()
              else if (widget.recurso != null)
                _buildExistingPreview(),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitForm,
                child: Text('Guardar'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPreview() {
    if (_tipoRecurso == 'imagen') {
      return Image.file(_selectedFile!);
    } else {
      return AspectRatio(
        aspectRatio: 16 / 9,
        child: VideoPlayer(_videoPlayerController!),
      );
    }
  }

  Widget _buildExistingPreview() {
    if (widget.recurso!.tipo == 'imagen') {
      return Image.network(widget.recurso!.url);
    } else {
      return AspectRatio(
        aspectRatio: 16 / 9,
        child: _videoPlayerController != null && _videoPlayerController!.value.isInitialized
            ? VideoPlayer(_videoPlayerController!)
            : Center(child: CircularProgressIndicator()),
      );
    }
  }

  void _pickFile() async {
    await _requestPermissions();

    try {
      final XFile? file;
      if (_tipoRecurso == 'imagen') {
        file = await _picker.pickImage(source: ImageSource.gallery);
      } else {
        file = await _picker.pickVideo(source: ImageSource.gallery);
      }

      if (file != null) {
        setState(() {
          _selectedFile = File(file!.path);
          if (_tipoRecurso == 'video') {
            if (_videoPlayerController != null) {
              _videoPlayerController!.dispose();
            }
            _videoPlayerController = VideoPlayerController.file(_selectedFile!)
              ..initialize().then((_) {
                setState(() {});
              });
          }
        });
      }
    } catch (e) {
      print('Error picking file: $e');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error seleccionando el archivo: $e')));
    }
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      final descripcion = _descripcionController.text;

      if (widget.recurso == null) {
        // Add new resource
        if (_selectedFile == null) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Por favor seleccione un archivo')));
          return;
        }
        await _recursoService.addRecursoEducativo(descripcion, _selectedFile!, _tipoRecurso);
      } else {
        // Update existing resource
        await _recursoService.updateRecursoEducativo(widget.recurso!.id, descripcion, _selectedFile, _tipoRecurso);
      }

      Navigator.pop(context, true);
    }
  }

  @override
  void dispose() {
    _descripcionController.dispose();
    if (_videoPlayerController != null) {
      _videoPlayerController!.dispose();
    }
    super.dispose();
  }
}

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${this.substring(1)}";
  }
}
