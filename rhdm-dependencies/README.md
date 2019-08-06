# RHDM Dependencies

Red Had Decision Manager POM dependencies.

## Use as a parent in pom.xml
```xml
<parent>
    <groupId>com.juliaaano</groupId>
    <artifactId>rhdm-dependencies</artifactId>
    <version>1.0.0-SNAPSHOT</version>
    <relativePath>../rhdm-dependencies</relativePath>
</parent>
```

## Use as an import in pom.xml
```xml
<dependencyManagement>
    <dependencies>
        <dependency>
            <groupId>com.juliaaano</groupId>
            <artifactId>rhdm-dependencies</artifactId>
            <version>${project.version}</version>
            <type>pom</type>
            <scope>import</scope>
        </dependency>
    </dependencies>
</dependencyManagement>
```
