
module TopModule (
    input clk,
    input resetn,
    input [2:0] r,
    output reg [2:0] g
);

    
    reg [1:0] state;
    reg [2:0] grant;

    
    always @(posedge clk or posedge resetn) begin
        if (resetn) begin
            state <= 2'b00;
            grant <= 3'b000;
        end else begin
            case (state)
                2'b00: begin
                    if (r[0] == 1) begin
                        state <= 2'b01;
                        grant <= 3'b001;
                    end else if (r[1] == 1) begin
                        state <= 2'b02;
                        grant <= 3'b010;
                    end else if (r[2] == 1) begin
                        state <= 2'b00;
                        grant <= 3'b000;
                    end
                end
                2'b01: begin
                    if (r[0] == 1) begin
                        state <= 2'b01;
                        grant <= 3'b001;
                    end else if (r[1] == 1) begin
                        state <= 2'b02;
                        grant <= 3'b010;
                    end else if (r[2] == 1) begin
                        state <= 2'b00;
                        grant <= 3'b000;
                    end
                end
                2'b02: begin
                    if (r[0] == 1) begin
                        state <= 2'b01;
                        grant <= 3'b001;
                    end else if (r[1] == 1) begin
                        state <= 2'b02;
                        grant <= 3'b010;
                    end else if (r[2] == 1) begin
                        state <= 2'b00;
                        grant <= 3'b000;
                    end
                end
            endcase
        end
    end

    
    always @(posedge clk or posedge resetn) begin
        if (resetn) begin
            g <= 3'b000;
        end else begin
            case (state)
                2'b00: begin
                    g <= 3'b000;
                end
                2'b01: begin
                    g <= 3'b001;
                end
                2'b02: begin
                    g <= 3'b010;
                end
            endcase
        end
    end

endmodule
