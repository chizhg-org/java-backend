package com.example.demo;

import lombok.Data;
import lombok.experimental.Accessors;

/** Model representing a cat **/
@Data
@Accessors(chain = true)
public class Cat {
  private String name;
  private int age;
}
