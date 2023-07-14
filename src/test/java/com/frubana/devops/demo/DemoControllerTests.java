package com.frubana.devops.demo;

import org.junit.jupiter.api.Test;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc;
import org.springframework.test.web.servlet.MockMvc;

import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.content;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;


@SpringBootTest
@AutoConfigureMockMvc
class DemoControllerTests {
    @Autowired
    private MockMvc mockMvc;

    @Test
    void noParamGreetingShouldReturnDefaultMessage() throws Exception {

        this.mockMvc.perform(get("/healthcheck")).andExpect(status().isOk())
                .andExpect(content().string("Hello World!"));
    }

    @Test
    void paramGreetingShouldReturnCustomMessage() throws Exception {

        this.mockMvc.perform(get("/healthcheck").param("name", "Spring Community"))
                .andExpect(status().isOk())
                .andExpect(content().string("Hello Spring Community!"));
    }

}
