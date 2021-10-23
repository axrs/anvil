import 'package:chassis_forge/chassis_forge.dart';
import 'package:smart_arg/smart_arg.dart';

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

  @Command(help: 'Builds the docker image')
  late BuildCommand build;

  @Command(help: 'Deploys the Docker Image to Docker Hub')
  late DeployCommand deploy;

  @Command(help: 'Formats the various Source codes and Files')
  late FormatCommand format;
}

void main(List<String> arguments) {
  initializeReflectable();
  Forge().runWith(arguments);
}
