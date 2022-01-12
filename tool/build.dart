import 'dart:io';

import 'package:chassis_forge/chassis_forge.dart';
import 'package:chassis_forge/smart_arg.dart';
import 'package:logging/logging.dart';
import 'package:rucksack/rucksack.dart';

final _log = Logger('af:build');

_buildDockerContainer(
  final IShell shell,
  final String dockerFile,
  final String tag, {
  final bool pull = false,
  final bool noCache = false,
  final String? anvilBase,
  final bool verbose = false,
}) async {
  String extraArgs = '';
  if (pull) {
    extraArgs += ' --pull';
  }
  if (noCache) {
    extraArgs += ' --no-cache';
  }
  final context = Directory('.docker_context');
  if (isFalse(context.existsSync())) {
    context.createSync();
  }
  _log.info('Building axrs/anvil:$tag');
  await shell.verbose(verbose) //
      .run(
    '''
docker build \\
  --progress plain \\
  $extraArgs \\
  --tag axrs/anvil:$tag \\
  --file $dockerFile \\
  ${isNotBlank(anvilBase) ? "--build-arg ANVIL_BASE_TAG=$anvilBase" : ''} \\
  .docker_context
''',
  );
}

@SmartArg.reflectable
@Parser(
  description: 'Builds the Docker Images',
)
class BuildCommand extends ChassisCommand with HelpOption, VerboseOption {
  @override
  @HelpArgument()
  late bool help = false;

  @override
  @BooleanArgument(
    help: 'Enable Verbose Output',
    short: 'v',
  )
  late bool verbose = false;

  @BooleanArgument(
    help: 'Pull the latest base container?',
  )
  late bool pull = true;

  @BooleanArgument(
    help: 'Build without using the Docker cache',
  )
  late bool noCache = false;

  void withNoCache(bool noCache) {
    this.noCache = noCache;
  }

  void withVerbosity(bool verbose) {
    this.verbose = verbose;
  }

  @override
  Future<void> run(final IShell shell, final SmartArg parentArguments) async {
    shell.requireCommand('docker');
    await _buildDockerContainer(
      shell,
      'Base.Dockerfile',
      'base',
      pull: pull,
      noCache: noCache,
      verbose: verbose,
    );
    //Build Base Cloud
    await _buildDockerContainer(
      shell,
      'Base_Cloud.Dockerfile',
      'base-cloud',
      pull: false,
      noCache: noCache,
      verbose: verbose,
    );
    //Build Java
    await _buildDockerContainer(
      shell,
      'Base_Java.Dockerfile',
      'base-java',
      pull: false,
      noCache: noCache,
      verbose: verbose,
      anvilBase: 'base',
    );
    //Build Flutter
    await _buildDockerContainer(
      shell,
      'Base_Flutter.Dockerfile',
      'base-flutter',
      pull: false,
      noCache: noCache,
      verbose: verbose,
      anvilBase: 'base',
    );
    //Build Java Cloud
    await _buildDockerContainer(
      shell,
      'Base_Java.Dockerfile',
      'base-java-cloud',
      pull: false,
      noCache: noCache,
      verbose: verbose,
      anvilBase: 'base-cloud',
    );
    //Build Flutter Cloud
    await _buildDockerContainer(
      shell,
      'Base_Flutter.Dockerfile',
      'base-flutter-cloud',
      pull: false,
      noCache: noCache,
      verbose: verbose,
      anvilBase: 'base-cloud',
    );
  }
}
