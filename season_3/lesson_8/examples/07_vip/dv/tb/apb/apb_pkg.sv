package apb_pkg;

    // Пакет

    `include "apb_packet.sv"

    // Конфигурация тестового сценария

    `include "apb_cfg.sv"

    // Генератор

    `include "apb_gen.sv"

    // Драйвер

    `include "apb_driver.sv"

    // Монитор

    `include "apb_monitor.sv"

    // Агент

    `include "apb_agent.sv"

    // Чекер

    `include "apb_checker.sv"

    // Окружение

    `include "apb_env.sv"

endpackage