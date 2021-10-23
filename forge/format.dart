import 'package:chassis_forge/chassis_forge.dart';
import 'package:chassis_forge/chassis_forge_markdown.dart';
import 'package:smart_arg/smart_arg.dart';

@SmartArg.reflectable
@Parser(
  description: 'Formats the various Source codes and Files',
)
class FormatCommand extends ChassisCommand with HelpOption {
  @override
  @HelpArgument()
  late bool help = false;

  @override
  Future<void> run(final IShell shell, final SmartArg parentArguments) async {
    await shell.markdownFormat();
  }
}
