
module TopModule (
    input        clk,
    input        in,
    input        reset,
    output reg [7:0] out_byte,
    output reg       done
);

    
    reg [7:0] data;
    reg [2:0] state;

    
    
    
    

    always @(posedge clk) begin
        if (reset) begin
            state   <= 3'b000;
            data    <= 8'b0;
            out_byte <= 8'b0;
            done    <= 1'b0;
        end else begin
            case (state)
                3'b000: begin 
                    if (in == 1'b0) begin
                        state <= 3'b001;
                    end else begin
                        state <= 3'b000;
                    end
                end
                3'b001: begin 
                    data[7] <= in;
                    state <= 3'b010;
                end
                3'b010: begin 
                    data <= {data[6:0], in};
                    if (state == 3'b010 && data[7] == 1'b0) begin
                        state <= 3'b010;
                    end else if (state == 3'b010 && data[7] == 1'b1) begin
                        state <= 3'b011;
                    end
                end
                3'b011: begin 
                    if (in == 1'b1) begin
                        state <= 3'b000;
                        out_byte <= data;
                        done <= 1'b1;
                    end else begin
                        state <= 3'b011;
                    end
                end
                default: begin
                    state <= 3'b000;
                    data <= 8'b0;
                    out_byte <= 8'b0;
                    done <= 1'b0;
                end
            endcase
        end
    end

endmodule
