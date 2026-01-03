package com.example.hellospringboot.controller;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;
import reactor.core.publisher.Mono;

@RestController
public class HelloController {

    @GetMapping("/")
    public Mono<String> hello() {
        return Mono.just("Terveiset reaktiivisesta REST-palvelusta taas jälleen!");
    }
}

