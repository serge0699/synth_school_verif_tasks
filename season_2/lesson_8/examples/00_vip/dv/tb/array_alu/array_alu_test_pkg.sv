package array_alu_test_pkg;

    // Импорт APB и AXI4

    import apb_pkg::*;
    import axi4_pkg::*;

    // Конфигурация

    `include "array_alu_cfg.sv"

    // Чекер

    `include "array_alu_checker.sv"

    // Окружение

    `include "array_alu_env.sv"

    // Тест

    `include "array_alu_test.sv"

endpackage