
module TopModule (
    input      cpu_overheated,
    output reg shut_off_computer,
    input      arrived,
    input      gas_tank_empty,
    output reg keep_driving,
    output reg zero_flag
);

    always @(*) begin
        if (cpu_overheated)
            shut_off_computer = 1;
    end

    always @(*) begin
        if (~arrived) begin
            keep_driving = ~gas_tank_empty;
            zero_flag = ~keep_driving;
        end else begin
            keep_driving = 1;
            zero_flag = 0;
        end
    end

endmodule
