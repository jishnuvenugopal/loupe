
module TopModule (
    input clk,
    input reset,
    input [2:0] s,
    output reg fr2,
    output reg fr1,
    output reg fr0,
    output reg dfr
);

    
    reg [1:0] state;
    reg [2:0] prev_s;
    reg [2:0] current_s;
    reg [2:0] prev_level;
    reg [2:0] current_level;

    
    reg [2:0] fr0_val = 3'b001;
    reg [2:0] fr1_val = 3'b010;
    reg [2:0] fr2_val = 3'b011;

    
    reg [2:0] fr0_ctrl = 3'b000;
    reg [2:0] fr1_ctrl = 3'b000;
    reg [2:0] fr2_ctrl = 3'b000;
    reg [2:0] dfr_ctrl = 3'b000;

    
    reg reset_signal;

    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            reset_signal = 1'b1;
            state = 2'b00;
            prev_s = 3'b000;
            current_s = 3'b000;
            prev_level = 3'b000;
            current_level = 3'b000;
            fr0_ctrl = 3'b000;
            fr1_ctrl = 3'b000;
            fr2_ctrl = 3'b000;
            dfr_ctrl = 3'b000;
        end else begin
            reset_signal = 1'b0;

            
            prev_s = current_s;
            current_s = s;

            
            prev_level = current_level;
            current_level = current_s;

            
            case (current_level)
                3'b000: state = 2'b00;
 
                3'b001: state = 2'b01;
 
                3'b010: state = 2'b02;
 
                3'b011: state = 2'b03;
 
            endcase

            
            case (state)
                2'b00: begin
                    fr0_ctrl = 3'b000;
                    fr1_ctrl = 3'b000;
                    fr2_ctrl = 3'b000;
                    dfr_ctrl = 3'b000;
                end
                2'b01: begin
                    fr0_ctrl = 3'b000;
                    fr1_ctrl = 3'b000;
                    fr2_ctrl = 3'b000;
                    dfr_ctrl = 3'b000;
                end
                2'b02: begin
                    fr0_ctrl = 3'b000;
                    fr1_ctrl = 3'b000;
                    fr2_ctrl = 3'b000;
                    dfr_ctrl = 3'b000;
                end
                2'b03: begin
                    fr0_ctrl = 3'b000;
                    fr1_ctrl = 3'b000;
                    fr2_ctrl = 3'b000;
                    dfr_ctrl = 3'b000;
                end
            endcase

            
            case (state)
                2'b00: begin
                    fr0 = fr0_val;
                    fr1 = fr0_val;
                    fr2 = fr0_val;
                    dfr = dfr_ctrl;
                end
                2'b01: begin
                    fr0 = fr0_val;
                    fr1 = fr0_val;
                    fr2 = fr0_val;
                    dfr = dfr_ctrl;
                end
                2'b02: begin
                    fr0 = fr0_val;
                    fr1 = fr0_val;
                    fr2 = fr0_val;
                    dfr = dfr_ctrl;
                end
                2'b03: begin
                    fr0 = fr0_val;
                    fr1 = fr0_val;
                    fr2 = fr0_val;
                    dfr = dfr_ctrl;
                end
            endcase
        end
    end

    
    assign fr2 = fr2_ctrl;
    assign fr1 = fr1_ctrl;
    assign fr0 = fr0_ctrl;
    assign dfr = dfr_ctrl;

endmodule
