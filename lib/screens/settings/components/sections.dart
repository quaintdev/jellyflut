import 'dart:io';
import 'package:easy_localization/src/public_ext.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_settings_ui/flutter_settings_ui.dart';

import 'package:jellyflut/components/locale_button_selector.dart';
import 'package:jellyflut/database/database.dart';
import 'package:jellyflut/globals.dart';
import 'package:jellyflut/models/enum/streaming_software.dart';
import 'package:jellyflut/models/enum/transcode_audio_codec.dart';
import 'package:jellyflut/screens/details/template/components/user_icon.dart';
import 'package:jellyflut/screens/form/forms/buttons/buttons.dart';
import 'package:jellyflut/services/auth/auth_service.dart';
import 'package:moor/moor.dart' hide Column;
import 'package:rxdart/subjects.dart';

part 'account_section.dart';
part 'audio_player_section.dart';
part 'video_bitrate_value_editor.dart';
part 'audio_bitrate_value_editor.dart';
part 'infos_section.dart';
part 'interface_section.dart';
part 'video_player_section.dart';
part 'download_path_section.dart';
part 'video_player_popup_button.dart';
part 'transcode_codec_popup_button.dart';
