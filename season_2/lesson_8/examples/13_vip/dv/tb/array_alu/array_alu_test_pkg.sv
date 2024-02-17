package array_alu_test_pkg;

    // Импорт Array ALU
    import array_alu_pkg::*;

    // Импорт APB и AXI4

    import apb_pkg::*;
    import axi4_pkg::*;

    // Конфигурация

    `include "array_alu_cfg.sv"

    // Генераторы

    `include "array_alu_apb_gen.sv"
    `include "array_alu_axi4_gen.sv"

    // Драйверы

    `include "array_alu_apb_driver.sv"

    // Чекеры

    `include "array_alu_checker.sv"

    // Окружение

    `include "array_alu_env.sv"

    // Тест

    `include "array_alu_test.sv"

endpackage