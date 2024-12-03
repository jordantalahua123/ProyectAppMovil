import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import '../../services/recurso_educativo_service.dart';
import '../../models/recurso_educativo_model.dart';
import 'detalles_educativo_view.dart';
import 'agregar_editar_recurso_view.dart';
import '../recipe/recipe_list_view.dart';
import '../recomendations/recomendation_view.dart';
import '../home_view.dart';

class EducativoView extends StatefulWidget {
  @override
  _EducativoViewState createState() => _EducativoViewState();
}

class _EducativoViewState extends State<EducativoView> {
  final RecursoEducativoService _recursoService = RecursoEducativoService();
  late Future<List<RecursoEducativo>> _recursosFuture;

  @override
  void initState() {
    super.initState();
    _recursosFuture = _recursoService.getRecursosEducativos();
  }

  void _navigateToAddEditView(BuildContext context, {RecursoEducativo? recurso}) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AgregarEditarRecursoView(recurso: recurso),
      ),
    );

    if (result != null && result == true) {
      _refreshRecursos();
    }
  }

  void _refreshRecursos() {
    setState(() {
      _recursosFuture = _recursoService.getRecursosEducativos();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Educación'),
        backgroundColor: Colors.lightGreen,
      ),
      body: FutureBuilder<List<RecursoEducativo>>(
        future: _recursosFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error cargando recursos educativos.'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No hay recursos educativos disponibles.'));
          }

          final recursos = snapshot.data!;
          return ListView.builder(
            padding: EdgeInsets.all(16.0),
            itemCount: recursos.length,
            itemBuilder: (context, index) {
              final recurso = recursos[index];
              return _buildCard(context, recurso);
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _navigateToAddEditView(context),
        child: Icon(Icons.add),
        backgroundColor: Colors.lightGreen,
      ),
      bottomNavigationBar: _buildBottomNavBar(), // Incluye el BottomNavigationBar aquí
    );
  }
 
  Widget _buildCard(BuildContext context, RecursoEducativo recurso) {
    return Card(
      child: Column(
        children: [
          ListTile(
            title: Text(recurso.descripcion),
            subtitle: Text(_capitalizeFirst(recurso.tipo)),
          ),
          if (recurso.tipo == 'imagen')
            Image.network(
              recurso.url,
              height: 200,
              width: double.infinity,
              fit: BoxFit.cover,
            )
          else
            VideoPlayerWidget(url: recurso.url),
          ButtonBar(
            children: [
              TextButton(
                child: Text('Editar'),
                onPressed: () => _navigateToAddEditView(context, recurso: recurso),
              ),
              TextButton(
                child: Text('Eliminar'),
                onPressed: () => _showDeleteConfirmationDialog(context, recurso),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _navigateToDetailsView(BuildContext context, RecursoEducativo recurso) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DetallesEducativoView(
          recurso: recurso,
        ),
      ),
    );
  }

  void _showDeleteConfirmationDialog(BuildContext context, RecursoEducativo recurso) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirmar eliminación'),
          content: Text('¿Estás seguro de que quieres eliminar este recurso?'),
          actions: <Widget>[
            TextButton(
              child: Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Eliminar'),
              onPressed: () async {
                await _recursoService.deleteRecursoEducativo(recurso.id);
                Navigator.of(context).pop();
                _refreshRecursos();
              },
            ),
          ],
        );
      },
    );
  }

  String _capitalizeFirst(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1);
  }

  Widget _buildBottomNavBar() {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      items: [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
        BottomNavigationBarItem(icon: Icon(Icons.restaurant_menu), label: 'Recetas'),
        BottomNavigationBarItem(icon: Icon(Icons.menu_book), label: 'Educativo'),
        BottomNavigationBarItem(icon: Icon(Icons.recommend), label: 'Recomendaciones'),
      ],
      onTap: (index) {
        switch (index) {
          case 0:
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => HomeView()),
            );
            break;
          case 1:
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => RecipeListView()),
            );
            break;
          case 2:
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => EducativoView()),
            );
            break;
          case 3:
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => RecommendationsView()),
            );
            break;
        }
      },
    );
  }
}

class VideoPlayerWidget extends StatefulWidget {
  final String url;

  VideoPlayerWidget({required this.url});

  @override
  _VideoPlayerWidgetState createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  late VideoPlayerController _controller;
  late Future<void> _initializeVideoPlayerFuture;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(widget.url);
    _initializeVideoPlayerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initializeVideoPlayerFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return AspectRatio(
            aspectRatio: _controller.value.aspectRatio,
            child: Stack(
              alignment: Alignment.bottomCenter,
              children: <Widget>[
                VideoPlayer(_controller),
                ControlsOverlay(controller: _controller),
                VideoProgressIndicator(_controller, allowScrubbing: true),
              ],
            ),
          );
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}

class ControlsOverlay extends StatelessWidget {
  final VideoPlayerController controller;

  ControlsOverlay({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        AnimatedSwitcher(
          duration: Duration(milliseconds: 50),
          reverseDuration: Duration(milliseconds: 200),
          child: controller.value.isPlaying
              ? SizedBox.shrink()
              : Container(
                  color: Colors.black26,
                  child: Center(
                    child: Icon(
                      Icons.play_arrow,
                      color: Colors.white,
                      size: 100.0,
                    ),
                  ),
                ),
        ),
        GestureDetector(
          onTap: () {
            controller.value.isPlaying ? controller.pause() : controller.play();
          },
        ),
      ],
    );
  }
}
