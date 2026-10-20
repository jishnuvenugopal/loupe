
module TopModule (
    input        clk,
    input        resetn,
    input [2:0]  r,    
    output reg [2:0] g 
);

    
    
    
    
    reg [1:0] state;

    
    always @(posedge clk or negedge resetn) begin
        if (!resetn)
            state <= 2'b00;
        else
            case (state)
                2'b00: begin 
                    if (r == 3'b000)
                        state <= 2'b00;
                    else if (r[0])
                        state <= 2'b01;
                    else if (r[1])
                        state <= 2'b10;
                    else
                        state <= 2'b00;
                end
                2'b01: begin 
                    if (r == 3'b000)
                        state <= 2'b00;
                    else if (r[0])
                        state <= 2'b01;
                    else if (r[1])
                        state <= 2'b10;
                    else
                        state <= 2'b00;
                end
                2'b10: begin 
                    if (r == 3'b000)
                        state <= 2'b00;
                    else if (r[1])
                        state <= 2'b10;
                    else if (r[2])
                        state <= 2'b11;
                    else
                        state <= 2'b00;
                end
                2'b11: begin 
                    if (r == 3'b000)
                        state <= 2'b00;
                    else if (r[1])
                        state <= 2'b10;
                    else if (r[2])
                        state <= 2'b11;
                    else
                        state <= 2'b00;
                end
                default: state <= 2'b00;
            endcase
    end

    
    always @(*) begin
        if (state == 2'b00) begin 
            if (r[2])
                g = 3'b001;
            else if (r[1])
                g = 3'b010;
            else if (r[0])
                g = 3'b100;
            else
                g = 3'b000;
        end
        else if (state == 2'b01) begin 
            if (r[0])
                g = 3'b001;
            else if (r[1])
                g = 3'b010;
            else
                g = 3'b000;
        end
        else if (state == 2'b10) begin 
            if (r[1])
                g = 3'b010;
            else if (r[2])
                g = 3'b100;
            else
                g = 3'b000;
        end
        else if (state == 2'b11) begin 
            if (r[1])
                g = 3'b010;
            else if (r[2])
                g = 3'b100;
            else
                g = 3'b000;
        end
        else
            g = 3'b000;
    end

endmodule
