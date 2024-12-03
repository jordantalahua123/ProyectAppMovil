import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../models/recurso_educativo_model.dart';
import '../../services/recurso_educativo_service.dart';

class DetallesEducativoView extends StatefulWidget {
  final RecursoEducativo recurso;

  DetallesEducativoView({required this.recurso});

  @override
  _DetallesEducativoViewState createState() => _DetallesEducativoViewState();
}

class _DetallesEducativoViewState extends State<DetallesEducativoView> {
  late VideoPlayerController? _videoPlayerController;
  bool _isVideoInitialized = false;

  @override
  void initState() {
    super.initState();
    if (widget.recurso.tipo == 'video') {
      _initializeVideoPlayer();
    }
  }

  void _initializeVideoPlayer() {
    _videoPlayerController = VideoPlayerController.network(widget.recurso.url)
      ..initialize().then((_) {
        setState(() {
          _isVideoInitialized = true;
        });
      });
  }

  @override
  void dispose() {
    _videoPlayerController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.recurso.descripcion),
        backgroundColor: Colors.lightGreen,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: _buildMediaWidget(),
            ),
            SizedBox(height: 24.0),
            Text(
              widget.recurso.descripcion,
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16.0),
            Text(
              'Tipo: ${widget.recurso.tipo}',
              style: TextStyle(
                fontSize: 16.0,
                color: Colors.grey[700],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMediaWidget() {
    if (widget.recurso.tipo == 'video') {
      return _isVideoInitialized
          ? AspectRatio(
              aspectRatio: _videoPlayerController!.value.aspectRatio,
              child: Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  VideoPlayer(_videoPlayerController!),
                  _VideoControls(controller: _videoPlayerController!),
                ],
              ),
            )
          : CircularProgressIndicator();
    } else {
      return CachedNetworkImage(
        imageUrl: widget.recurso.url,
        width: 300,
        height: 300,
        fit: BoxFit.cover,
        placeholder: (context, url) => CircularProgressIndicator(),
        errorWidget: (context, url, error) => Icon(Icons.error),
      );
    }
  }
}

class _VideoControls extends StatelessWidget {
  final VideoPlayerController controller;

  const _VideoControls({Key? key, required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black26,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            icon: Icon(
              controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
              color: Colors.white,
            ),
            onPressed: () {
              controller.value.isPlaying ? controller.pause() : controller.play();
            },
          ),
        ],
      ),
    );
  }
}