
module TopModule (
    input  wire clk,
    input  wire resetn,
    input  wire x,
    input  wire y,
    output reg  f,
    output reg  g
);

    
    
    reg [1:0] state;

    
    always @(posedge clk) begin
        if (!resetn) begin
            state <= 2'b00;
            f     <= 1'b0;
            g     <= 1'b0;
        end else begin
            case (state)
                2'b00: begin 
                    if (!resetn) begin
                        state <= 2'b01;
                        f     <= 1'b1;
                    end else begin
                        state <= 2'b00;
                        f     <= 1'b0;
                    end
                end
                2'b01: begin 
                    if (!resetn) begin
                        state <= 2'b10;
                        f     <= 1'b0;
                    end else begin
                        state <= 2'b01;
                        f     <= 1'b1;
                    end
                end
                2'b10: begin 
                    if (!resetn) begin
                        state <= 2'b11;
                        g     <= 1'b0;
                    end else begin
                        if (x) begin
                            state <= 2'b10;
                            g     <= 1'b0;
                        end else begin
                            state <= 2'b11;
                            g     <= 1'b0;
                        end
                    end
                end
                2'b11: begin 
                    if (!resetn) begin
                        state <= 2'b00;
                        g     <= 1'b0;
                    end else begin
                        if (y) begin
                            state <= 2'b11;
                            g     <= 1'b1;
                        end else begin
                            state <= 2'b11;
                            g     <= 1'b0;
                        end
                    end
                end
                default: begin
                    state <= 2'b00;
                    f     <= 1'b0;
                    g     <= 1'b0;
                end
            endcase
        end
    end

endmodule
