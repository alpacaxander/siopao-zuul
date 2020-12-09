FROM maven:3-openjdk-8 as BUILDER

WORKDIR /builder

# Add pom and get dependancies to cache for faster builds
COPY ./pom.xml ./
RUN mvn -B -e -C -T 1C org.apache.maven.plugins:maven-dependency-plugin:3.0.2:go-offline

COPY ./src ./src
RUN mvn clean package -DskipTests

FROM amazoncorretto:8

WORKDIR /zuul

COPY --from=BUILDER builder/target/zuul-1.0-SNAPSHOT.jar ./target/zuul.jar

CMD ["java", "-cp", "./target/zuul.jar", "org.springframework.boot.loader.JarLauncher"]