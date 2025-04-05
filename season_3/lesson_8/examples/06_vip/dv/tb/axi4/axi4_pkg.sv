package axi4_pkg;

    typedef enum {
        AW, W, B, AR, R
    } axi4_channel_t;

    typedef enum logic [2:0] {
        OKAY   = 3'b000,
        SLVERR = 3'b010
    } resp_t;

    // Пакет

    `include "axi4_packet.sv"

    // Конфигурация тестового сценария

    `include "axi4_cfg.sv"

    // Генератор

    `include "axi4_gen.sv"

    // Драйвер

    `include "axi4_driver.sv"

    // Монитор

    `include "axi4_monitor.sv"

    // Агент

    `include "axi4_agent.sv"

    // Чекер

    `include "axi4_checker.sv"

    // Окружение

    `include "axi4_env.sv"

endpackage