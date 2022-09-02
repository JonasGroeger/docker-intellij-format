# docker-intellij-format

Format your source code with IntelliJ on the command line!

Note that this **does not do the 'optimize imports' part**. This is something you can do with i.e. [Checkstyle](https://checkstyle.org/). You can find an example config here in this repository. You can make the project compliant by running the format step once manually on all files.

## Usage

* `make build`
* Mount your exported IntelliJ code style `.xml` file to `/default.xml` using `--volume .../yours.xml:/default.xml`
* Use the below `docker run ...` command below
* You can set the environment variable `FAIL_IF_NONCOMPLIANT` to `true` to fail if the formatting does not match.
  In the below example `docker run ...` command, add `-e FAIL_IF_NONCOMPLIANT=true` to do just that.
  The default is `false`.

### Example for FIT-Connect

Format all `.java` files in the `src/` subdirectory (recursively)

```console
$ make build
$ docker run \
    --rm \
    --user $(id -u):$(id -g) \
    --volume $(pwd):/data \
    --volume .../yours.xml:/default.xml \
    docker-intellij-format:latest \
    /default.xml -r -m '*.java' src
```

# Internals

## No Star Imports

```
<module name="AvoidStarImport"/>

ij_java_class_count_to_use_import_on_demand = 99
ij_java_names_count_to_use_import_on_demand = 99

<option name="CLASS_COUNT_TO_USE_IMPORT_ON_DEMAND" value="99" />
<option name="NAMES_COUNT_TO_USE_IMPORT_ON_DEMAND" value="99" />
```

## Import Order

```
<module name="ImportOrder">
    <property name="groups" value="*,javax,java"/>
    <property name="ordered" value="true"/>
    <property name="separated" value="true"/>
    <property name="option" value="bottom"/>
    <property name="sortStaticImportsAlphabetically" value="true"/>
</module>

ij_java_imports_layout = *,|,javax.**,|,java.**,|,$*

<option name="IMPORT_LAYOUT_TABLE">
    <value>
    <package name="" withSubpackages="true" static="false" />
    <emptyLine />
    <package name="javax" withSubpackages="true" static="false" />
    <emptyLine />
    <package name="java" withSubpackages="true" static="false" />
    <emptyLine />
    <package name="" withSubpackages="true" static="true" />
    </value>
</option>
```
