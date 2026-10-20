
module TopModule (
    input  wire d,
    input  wire done_counting,
    input  wire ack,
    input  wire [9:0] state,
    output reg  B3_next,
    output reg  S_next,
    output reg  S1_next,
    output reg  Count_next,
    output reg  Wait_next,
    output wire done,
    output wire counting,
    output wire shift_ena
);

    
    reg [9:0] state_reg;

    
    always @(*) begin
        case (state)
            10'b0000000001: begin 
                if (d == 1'b0) begin
                    S_next = 1'b1;
                    S1_next = 1'b0;
                    B3_next = 1'b0;
                    Count_next = 1'b0;
                    Wait_next = 1'b0;
                end else begin
                    S_next = 1'b0;
                    S1_next = 1'b1;
                    B3_next = 1'b0;
                    Count_next = 1'b0;
                    Wait_next = 1'b0;
                end
            end
            10'b0000000010: begin 
                if (d == 1'b0) begin
                    S_next = 1'b0;
                    S1_next = 1'b1;
                    B3_next = 1'b0;
                    Count_next = 1'b0;
                    Wait_next = 1'b0;
                end else begin
                    S_next = 1'b0;
                    S1_next = 1'b1;
                    B3_next = 1'b0;
                    Count_next = 1'b0;
                    Wait_next = 1'b0;
                end
            end
            10'b0000000100: begin 
                if (d == 1'b0) begin
                    S_next = 1'b0;
                    S1_next = 1'b1;
                    B3_next = 1'b0;
                    Count_next = 1'b0;
                    Wait_next = 1'b0;
                end else begin
                    S_next = 1'b0;
                    S1_next = 1'b1;
                    B3_next = 1'b0;
                    Count_next = 1'b0;
                    Wait_next = 1'b0;
                end
            end
            10'b0000001000: begin 
                if (d == 1'b0) begin
                    S_next = 1'b0;
                    S1_next = 1'b1;
                    B3_next = 1'b0;
                    Count_next = 1'b0;
                    Wait_next = 1'b0;
                end else begin
                    S_next = 1'b0;
                    S1_next = 1'b1;
                    B3_next = 1'b0;
                    Count_next = 1'b0;
                    Wait_next = 1'b0;
                end
            end
            10'b0000010000: begin 
                if (d == 1'b0) begin
                    S_next = 1'b0;
                    S1_next = 1'b0;
                    B3_next = 1'b0;
                    Count_next = 1'b0;
                    Wait_next = 1'b0;
                end else begin
                    S_next = 1'b0;
                    S1_next = 1'b0;
                    B3_next = 1'b0;
                    Count_next = 1'b0;
                    Wait_next = 1'b0;
                end
            end
            10'b0000100000: begin 
                if (d == 1'b0) begin
                    S_next = 1'b0;
                    S1_next = 1'b0;
                    B3_next = 1'b0;
                    Count_next = 1'b0;
                    Wait_next = 1'b0;
                end else begin
                    S_next = 1'b0;
                    S1_next = 1'b0;
                    B3_next = 1'b0;
                    Count_next = 1'b0;
                    Wait_next = 1'b0;
                end
            end
            10'b0001000000: begin 
                if (d == 1'b0) begin
                    S_next = 1'b0;
                    S1_next = 1'b0;
                    B3_next = 1'b0;
                    Count_next = 1'b0;
                    Wait_next = 1'b0;
                end else begin
                    S_next = 1'b0;
                    S1_next = 1'b0;
                    B3_next = 1'b0;
                    Count_next = 1'b0;
                    Wait_next = 1'b0;
                end
            end
            10'b0010000000: begin 
                if (d == 1'b0) begin
                    S_next = 1'b0;
                    S1_next = 1'b0;
                    B3_next = 1'b0;
                    Count_next = 1'b0;
                    Wait_next = 1'b0;
                end else begin
                    S_next = 1'b0;
                    S1_next = 1'b0;
                    B3_next = 1'b0;
                    Count_next = 1'b0;
                    Wait_next = 1'b0;
                end
            end
            10'b0100000000: begin 
                if (d == 1'b0) begin
                    S_next = 1'b0;
                    S1_next = 1'b0;
                    B3_next = 1'b0;
                    Count_next = 1'b0;
                    Wait_next = 1'b0;
                end else begin
                    S_next = 1'b0;
                    S1_next = 1'b0;
                    B3_next = 1'b0;
                    Count_next = 1'b0;
                    Wait_next = 1'b0;
                end
            end
            10'b1000000000: begin 
                if (d == 1'b0) begin
                    S_next = 1'b0;
                    S1_next = 1'b0;
                    B3_next = 1'b0;
                    Count_next = 1'b0;
                    Wait_next = 1'b0;
                end else begin
                    S_next = 1'b0;
                    S1_next = 1'b0;
                    B3_next = 1'b0;
                    Count_next = 1'b0;
                    Wait_next = 1'b0;
                end
            end
            default: begin
                S_next = 1'b0;
                S1_next = 1'b0;
                B3_next = 1'b0;
                Count_next = 1'b0;
                Wait_next = 1'b0;
            end
        endcase
    end

    
    always @(*) begin
        case (state)
            10'b0000000001: begin 
                done = 1'b0;
                counting = 1'b0;
                shift_ena = 1'b0;
            end
            10'b0000000010: begin 
                done = 1'b0;
                counting = 1'b0;
                shift_ena = 1'b0;
            end
            10'b0000000100: begin 
                done = 1'b0;
                counting = 1'b0;
                shift_ena = 1'b0;
            end
            10'b0000001000: begin 
                done = 1'b0;
                counting = 1'b0;
                shift_ena = 1'b0;
            end
            10'b0000010000: begin 
                done = 1'b0;
                counting = 1'b0;
                shift_ena = 1'b0;
            end
            10'b0000100000: begin 
                done = 1'b0;
                counting = 1'b0;
                shift_ena = 1'b0;
            end
            10'b0001000000: begin 
                done = 1'b0;
                counting = 1'b0;
                shift_ena = 1'b0;
            end
            10'b0010000000: begin 
                done = 1'b0;
                counting = 1'b0;
                shift_ena = 1'b0;
            end
            10'b0100000000: begin 
                done = 1'b0;
                counting = 1'b1;
                shift_ena = 1'b0;
            end
            10'b1000000000: begin 
                if (ack == 1'b0) begin
                    done = 1'b0;
                    counting = 1'b0;
                    shift_ena = 1'b0;
                end else begin
                    done = 1'b1;
                    counting = 1'b0;
                    shift_ena = 1'b0;
                end
            end
            default: begin
                done = 1'b0;
                counting = 1'b0;
                shift_ena = 1'b0;
            end
        endcase
    end

endmodule
