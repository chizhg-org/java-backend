package com.example.demo;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@CrossOrigin
@RestController
@RequiredArgsConstructor
@Slf4j
public class CatController {
  @GetMapping("/api/v1/cats")
  public List<Cat> getAllCats() {
    log.info("Getting all cats!");
    Cat cat1 = new Cat().setName("Bob").setAge(5);
    Cat cat2 = new Cat().setName("Tom").setAge(8);
    Cat cat3 = new Cat().setName("Jack").setAge(9);
    return List.of(cat1, cat2, cat3);
  }
  @GetMapping("/api/v1/cats/meow")
  public String talk() {
    return "miau, miau!";
  }
}
