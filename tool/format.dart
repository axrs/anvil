import 'package:chassis_forge/chassis_forge.dart';
import 'package:chassis_forge/chassis_forge_markdown.dart';
import 'package:chassis_forge/smart_arg.dart';

@SmartArg.reflectable
@Parser(
  description: 'Formats the various Source codes and Files',
)
class FormatCommand extends ChassisCommand with HelpOption {
  @override
  @HelpArgument()
  late bool help = false;

  @override
  Future<void> run(IShell shell, SmartArg parentArguments) async {
    await shell.markdownFormat();
  }
}
