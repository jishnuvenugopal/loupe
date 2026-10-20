
module top_module (
    input wire x,
    input wire [2:0] y,
    output wire Y0,
    output wire z
);

    reg [2:0] present_state;
    reg [2:0] next_state;
    reg [2:0] Y_next;

    
    assign Y0 = Y_next[0];
    assign z = Y_next[2];

    
    always @(present_state or x or y) begin
        case (present_state)
            3'b000: 
                if (x == 0) 
                    begin
                        next_state = 3'b000;
                        Y_next = 3'b000;
                    end
                else 
                    begin
                        next_state = 3'b001;
                        Y_next = 3'b001;
                    end
            3'b001: 
                if (x == 0) 
                    begin
                        next_state = 3'b001;
                        Y_next = 3'b100;
                    end
                else 
                    begin
                        next_state = 3'b100;
                        Y_next = 3'b100;
                    end
            3'b010: 
                if (x == 0) 
                    begin
                        next_state = 3'b010;
                        Y_next = 3'b001;
                    end
                else 
                    begin
                        next_state = 3'b001;
                        Y_next = 3'b010;
                    end
            3'b011: 
                if (x == 0) 
                    begin
                        next_state = 3'b001;
                        Y_next = 3'b010;
                    end
                else 
                    begin
                        next_state = 3'b010;
                        Y_next = 3'b010;
                    end
            3'b100: 
                if (x == 0) 
                    begin
                        next_state = 3'b011;
                        Y_next = 3'b100;
                    end
                else 
                    begin
                        next_state = 3'b100;
                        Y_next = 3'b100;
                    end

            default: next_state = 3'b000;
 
        endcase
    end

    
    always @(posedge clk or negedge rst) begin
        if (rst == 1'b0) 
            present_state <= 3'b000;
        else 
            present_state <= next_state;
    end

endmodule
