// ignore_for_file: constant_identifier_names

enum MediaType {
  TEXT('text'),
  IMAGE('image'),
  AUDIO('audio'),
  VIDEO('video'),
  GIF('gif'),
  FILE('file');

  const MediaType(this.type);
  final String type;
}
