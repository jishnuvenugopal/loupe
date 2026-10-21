
module TopModule (
    input wire [7:0] in,
    output reg [2:0] pos
);

    
    reg [2:0] state;

    
    always @(posedge in or posposedge state) begin
        if (in[7]) begin
            state = 3'b001;
        end else if (in[6]) begin
            state = 3'b010;
        end else if (in[5]) begin
            state = 3'b011;
        end else if (in[4]) begin
            state = 3'b100;
        end else if (in[3]) begin
            state = 3'b101;
        end else if (in[2]) begin
            state = 3'b110;
        end else if (in[1]) begin
            state = 3'b111;
        end else if (in[0]) begin
            state = 3'b111;
        end else begin
            state = 3'b000;
        end
    end

    
    always @(*) begin
        pos = state;
    end

endmodule
