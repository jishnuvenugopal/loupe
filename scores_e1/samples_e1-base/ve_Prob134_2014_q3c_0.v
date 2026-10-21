
module TopModule (
    input wire x,
    input wire [2:0] y,
    output reg Y0,
    output reg z
);

    
    reg [1:0] state;

    
    always @(posedge clk or negedge rst) begin
        if (rst) begin
            state <= 2'b00;
        end else begin
            state <= next_state;
        end
    end

    
    always @(posedge clk or negedge rst) begin
        if (rst) begin
            next_state <= 2'b00;
        end else begin
            case (state)
                2'b00: begin
                    if (x == 0) begin
                        next_state <= 2'b00;
                    end else begin
                        next_state <= 2'b01;
                    end
                end
                2'b01: begin
                    if (x == 0) begin
                        next_state <= 2'b01;
                    end else begin
                        next_state <= 2'b10;
                    end
                end
                2'b10: begin
                    if (x == 0) begin
                        next_state <= 2'b10;
                    end else begin
                        next_state <= 2'b01;
                    end
                end
                2'b11: begin
                    if (x == 0) begin
                        next_state <= 2'b11;
                    end else begin
                        next_state <= 2'b10;
                    end
                end
            endcase
        end
    end

    
    always @(posedge clk or negedge rst) begin
        if (rst) begin
            Y0 <= 1'b0;
            z <= 1'b0;
        end else begin
            Y0 <= next_state[0];
            z <= next_state[1];
        end
    end

endmodule
