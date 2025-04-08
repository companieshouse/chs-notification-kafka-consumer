package uk.gov.companieshouse.chs.notification.kafka.consumer;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.web.SecurityFilterChain;

import static org.springframework.http.HttpMethod.GET;


@Configuration
@EnableWebSecurity
public class SecurityConfig {
    
    @Bean
    public SecurityFilterChain filterChain(
            @Value("${management.endpoints.web.path-mapping.health}") final String healthcheckUrl,
            final HttpSecurity http
    ) throws Exception {
        return http.authorizeHttpRequests(request -> request
                .requestMatchers(GET, healthcheckUrl).permitAll()
                .anyRequest().denyAll()
        ).build();
    }
    
}
