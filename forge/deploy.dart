import 'package:chassis_forge/chassis_forge.dart';
import 'package:logging/logging.dart';
import 'package:smart_arg/smart_arg.dart';

import 'build.dart';

final Logger _log = Logger('af:deploy');

@SmartArg.reflectable
@Parser(
  description: 'Deploys the Docker Image to Docker Hub',
)
class DeployCommand extends ChassisCommand with HelpOption {
  @override
  @HelpArgument()
  late bool help = false;

  @BooleanArgument(
    help: 'Enable verbose Docker Image build',
  )
  late bool verboseBuild = false;

  @BooleanArgument(
    help: 'Build without using the Docker cache',
  )
  late bool cached = false;

  @StringArgument(
    help: 'Image Name',
  )
  late String tag = 'axrs/anvil:latest';

  @override
  Future<void> run(final IShell shell, final SmartArg parentArguments) async {
    _log.info('Building Docker Image');
    final BuildCommand build = BuildCommand() //
      ..withVerbosity(verboseBuild)
      ..withNoCache(!cached)
      ..withTagWhenNotEmpty(tag);
    await build.run(shell, parentArguments);
    _log.info('Deploying Docker Image ${build.tag}');
    await shell.verbose().run('docker push ${build.tag}');
  }
}
