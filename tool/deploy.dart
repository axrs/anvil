import 'package:chassis_forge/chassis_forge.dart';
import 'package:chassis_forge/smart_arg.dart';
import 'package:logging/logging.dart';

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
  Future<void> run(IShell shell, SmartArg parentArguments) async {
    _log.info('Building Docker Image');
    var build = BuildCommand() //
      ..withVerbosity(verboseBuild)
      ..withNoCache(!cached);
    await build.run(shell, parentArguments);
    _log.info('Deploying Docker Images. This may take a while...');
    await shell.verbose().run('docker push axrs/anvil:base');
    await shell.verbose().run('docker push axrs/anvil:base-cloud');
    await shell.verbose().run('docker push axrs/anvil:base-java');
    await shell.verbose().run('docker push axrs/anvil:base-java-cloud');
  }
}
