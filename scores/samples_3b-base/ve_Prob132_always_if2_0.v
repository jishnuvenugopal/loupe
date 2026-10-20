
module TopModule (
    input      cpu_overheated,
    output reg shut_off_computer,
    input      arrived,
    input      gas_tank_empty,
    output reg keep_driving,
    output reg zero_flag
);

    
    reg zero_flag_reg = 0;

    always @(*) begin
        
        if (cpu_overheated)
            shut_off_computer = 1;
        else
            shut_off_computer = 0;

        
        if (~arrived && gas_tank_empty)
            keep_driving = 1;
        else
            keep_driving = 0;

        
        reg sum = 0;
        sum = arrived + gas_tank_empty;

        
        if (sum == 0)
            zero_flag_reg = 1;
        else
            zero_flag_reg = 0;

        
        zero_flag = zero_flag_reg;
    end

endmodule
