plugins {
	java
	id("org.springframework.boot") version "4.0.5"
	id("io.spring.dependency-management") version "1.1.7"
	id("org.openapi.generator") version "7.22.0"
}

group = "ru.kpfu.itis.sorokin"
version = "0.0.1-SNAPSHOT"

val postgresql: String by project

java {
	toolchain {
		languageVersion = JavaLanguageVersion.of(25)
	}
}

repositories {
	mavenCentral()
}

dependencies {
	compileOnly("org.projectlombok:lombok")
	annotationProcessor("org.projectlombok:lombok")

	implementation("org.springframework.boot:spring-boot-starter")
	implementation("org.springframework.boot:spring-boot-starter-web")
	implementation("org.springframework.boot:spring-boot-starter-security")
	implementation("org.springframework.boot:spring-boot-starter-data-jpa")
	implementation("org.springframework.boot:spring-boot-starter-validation")
	implementation("org.springframework.boot:spring-boot-starter-mail")
	implementation("org.springframework.boot:spring-boot-starter-thymeleaf")
	implementation("org.springframework.boot:spring-boot-starter-data-redis")
	implementation("org.springframework.boot:spring-boot-starter-liquibase")
	implementation("org.springframework.boot:spring-boot-starter-actuator")
	implementation("org.springframework.boot:spring-boot-starter-freemarker")
	implementation("org.postgresql:postgresql:$postgresql")
	implementation("org.springdoc:springdoc-openapi-starter-webmvc-ui:3.0.3")
	implementation("org.commonmark:commonmark:0.28.0")
	implementation("org.jsoup:jsoup:1.21.2")

	testImplementation("org.springframework.boot:spring-boot-starter-test")
	testRuntimeOnly("org.junit.platform:junit-platform-launcher")
}

tasks.withType()

tasks.withType<Test> {
	useJUnitPlatform()
}

val openApiSpec = "$projectDir/src/main/resources/api.yml"
val openApiGeneratedDir = layout.buildDirectory.dir("generated").get().asFile.absolutePath

openApiGenerate {
	inputSpec.set(openApiSpec)
	outputDir.set(openApiGeneratedDir)
	generatorName.set("spring")

	modelPackage.set("ru.kpfu.itis.sorokin.sdevpoint.api.generated.dto")
	apiPackage.set("ru.kpfu.itis.sorokin.sdevpoint.api.generated.api")

	configOptions.set(
		mapOf(
			"useJakartaEe" to "true",
			"useSpringBoot3" to "true",
			"library" to "spring-boot",
			"interfaceOnly" to "true",
			"skipDefaultInterface" to "true",
			"useBeanValidation" to "true",
			"useTags" to "true",
			"dateLibrary" to "java8",
			"openApiNullable" to "false",
			"documentationProvider" to "none",
			"useResponseEntity" to "true"
		)
	)

	globalProperties.set(
		mapOf(
			"apiTests" to "false",
			"modelTests" to "false",
			"apiDocs" to "false",
			"modelDocs" to "false"
		)
	)
}

sourceSets {
	getByName("main") {
		java {
			srcDir(layout.buildDirectory.dir("generated/src/main/java"))
		}
	}
}

tasks.named("compileJava") {
	dependsOn("openApiGenerate")
}