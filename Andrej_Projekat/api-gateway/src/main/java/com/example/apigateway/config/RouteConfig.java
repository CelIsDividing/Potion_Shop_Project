package com.example.apigateway.config;

import org.springframework.cloud.gateway.route.RouteLocator;
import org.springframework.cloud.gateway.route.builder.RouteLocatorBuilder;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.http.HttpStatus;

/**
 * Route management: defines how requests are routed to microservices.
 * The discovery locator (application.properties) still uses Eureka for dynamic routes;
 * additional or override routes can be added here as needed.
 */
@Configuration
public class RouteConfig {

    @Bean
    public RouteLocator customRouteLocator(RouteLocatorBuilder builder) {
        return builder.routes()
                // Redirect /actuator/info to login page
                .route("redirect-actuator-info", r -> r
                        .path("/actuator/info")
                        .and().method("GET")
                        .filters(f -> f.setStatus(HttpStatus.FOUND)
                                .addResponseHeader("Location", "/web-app/login"))
                        .uri("no://op"))
                .build();
    }
}
