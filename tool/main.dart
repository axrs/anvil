import 'package:chassis_forge/chassis_forge.dart';
import 'package:chassis_forge/smart_arg.dart';

import 'build.dart';
import 'deploy.dart';
import 'format.dart';
// ignore: unused_import
import 'main.reflectable.dart';

@SmartArg.reflectable
@Parser(
  description: 'Anvil Forge Tools',
)
class Forge extends ChassisForge with HelpOption, VerboseOption {
  @override
  @BooleanArgument(
    short: 'v',
    help: 'Enable Verbose Output',
  )
  late bool verbose = false;

  @override
  @HelpArgument()
  late bool help = false;

  @Command()
  late BuildCommand build;

  @Command()
  late DeployCommand deploy;

  @Command()
  late FormatCommand format;
}

void main(List<String> arguments) {
  initializeReflectable();
  Forge().runWith(arguments);
}
