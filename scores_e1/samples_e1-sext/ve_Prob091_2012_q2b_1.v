
module TopModule (
    input wire [5:0] y,
    input wire w,
    output reg Y1,
    output reg Y3
);

    
    reg [5:0] state;
    reg [1:0] y1_flipflop;
    reg [1:0] y3_flipflop;

    
    always @(*) begin
        state = 6'b000001;
 
    end

    
    always @(y or w) begin
        case (state)
            6'b000001: begin 
                if (w) begin
                    state = 6'b000010;
 
                end else begin
                    state = 6'b000001;
 
                end
            end
            6'b000010: begin 
                if (w) begin
                    state = 6'b000100;
 
                end else begin
                    state = 6'b000010;
 
                end
            end
            6'b000100: begin 
                if (w) begin
                    state = 6'b001000;
 
                end else begin
                    state = 6'b000100;
 
                end
            end
            6'b001000: begin 
                if (w) begin
                    state = 6'b100000;
 
                end else begin
                    state = 6'b001000;
 
                end
            end
            6'b100000: begin 
                if (w) begin
                    state = 6'b100000;
 
                end else begin
                    state = 6'b001000;
 
                end
            end
            default: begin 
                state = 6'b000001;
 
            end
        endcase
    end

    
    always @(*) begin
        y1_flipflop = state[1];
        y3_flipflop = state[3];
    end

    
    assign Y1 = y1_flipflop;
    assign Y3 = y3_flipflop;

endmodule
