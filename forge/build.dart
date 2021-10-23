import 'package:chassis_forge/chassis_forge.dart';
import 'package:rucksack/rucksack.dart';
import 'package:smart_arg/smart_arg.dart';

@SmartArg.reflectable
@Parser(
  description: 'Builds the Docker Image',
)
class BuildCommand extends ChassisCommand with HelpOption, VerboseOption {
  @override
  @HelpArgument()
  late bool help = false;

  late bool verbose = true;

  @BooleanArgument(
    help: 'Pull the latest base container?',
  )
  late bool pull = true;

  @BooleanArgument(
    help: 'Build without using the Docker cache',
  )
  late bool noCache = false;

  @StringArgument(
    help: 'Image Name',
  )
  late String tag = 'axrs/anvil:latest';

  void withTagWhenNotEmpty(String? tag) {
    if (isNotBlank(tag)) {
      this.tag = tag!;
    }
  }

  void withNoCache(bool noCache) {
    this.noCache = noCache;
  }

  void withVerbosity(bool verbose) {
    this.verbose = verbose;
  }

  @override
  Future<void> run(final IShell shell, final SmartArg parentArguments) async {
    shell.requireCommand('docker');
    String extraArgs = '';
    if (pull) {
      extraArgs += ' --pull';
    }
    if (noCache) {
      extraArgs += ' --no-cache';
    }
    await shell
        .verbose(verbose: verbose) //
        .run('docker build --progress plain $extraArgs --tag $tag .');
  }
}
