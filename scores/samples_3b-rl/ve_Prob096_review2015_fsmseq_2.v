
module TopModule (
    input  wire clk,
    input  wire reset,
    input  wire data,
    output reg  start_shifting
);

    
    reg [3:0] state;
    reg [3:0] prev_data;
    reg [3:0] prev_prev_data;
    reg [3:0] prev_prev_prev_data;

    
    
    
    
    
    
    
    
    
    

    always @(posedge clk) begin
        if (reset) begin
            state      <= 4'b0000;
            prev_data  <= 4'b0000;
            prev_prev_data <= 4'b0000;
            prev_prev_prev_data <= 4'b0000;
            start_shifting <= 1'b0;
        end else begin
            case (state)
                4'b0000: begin
                    if (data == 1'b1) begin
                        state <= 4'b0001;
                    end else begin
                        state <= 4'b0000;
                    end
                end
                4'b0001: begin
                    if (data == 1'b1) begin
                        state <= 4'b0010;
                    end else begin
                        state <= 4'b0000;
                    end
                end
                4'b0010: begin
                    if (data == 1'b0) begin
                        state <= 4'b0011;
                    end else begin
                        state <= 4'b0000;
                    end
                end
                4'b0011: begin
                    if (data == 1'b1) begin
                        state <= 4'b0100;
                    end else begin
                        state <= 4'b0000;
                    end
                end
                4'b0100: begin
                    if (data == 1'b0) begin
                        state <= 4'b0101;
                    end else begin
                        state <= 4'b0000;
                    end
                end
                4'b0101: begin
                    if (data == 1'b1) begin
                        state <= 4'b0110;
                    end else begin
                        state <= 4'b0000;
                    end
                end
                4'b0110: begin
                    if (data == 1'b0) begin
                        state <= 4'b0111;
                    end else begin
                        state <= 4'b0000;
                    end
                end
                4'b0111: begin
                    if (data == 1'b1) begin
                        state <= 4'b1000;
                    end else begin
                        state <= 4'b0000;
                    end
                end
                4'b1000: begin
                    if (data == 1'b1) begin
                        state <= 4'b1001;
                    end else begin
                        state <= 4'b0000;
                    end
                end
                4'b1001: begin
                    if (data == 1'b0) begin
                        state <= 4'b1010;
                    end else begin
                        state <= 4'b0000;
                    end
                end
                4'b1010: begin
                    if (data == 1'b1) begin
                        state <= 4'b1011;
                    end else begin
                        state <= 4'b0000;
                    end
                end
                4'b1011: begin
                    if (data == 1'b0) begin
                        state <= 4'b1100;
                    end else begin
                        state <= 4'b0000;
                    end
                end
                4'b1100: begin
                    if (data == 1'b1) begin
                        state <= 4'b1101;
                    end else begin
                        state <= 4'b0000;
                    end
                end
                4'b1101: begin
                    if (data == 1'b0) begin
                        state <= 4'b1110;
                    end else begin
                        state <= 4'b0000;
                    end
                end
                4'b1110: begin
                    if (data == 1'b1) begin
                        state <= 4'b1111;
                    end else begin
                        state <= 4'b0000;
                    end
                end
                4'b1111: begin
                    if (data == 1'b0) begin
                        state <= 4'b1111;
                        start_shifting <= 1'b1;
                    end else begin
                        state <= 4'b0000;
                        start_shifting <= 1'b0;
                    end
                end
                default: begin
                    state <= 4'b0000;
                    start_shifting <= 1'b0;
                end
            endcase
        end
    end

endmodule
