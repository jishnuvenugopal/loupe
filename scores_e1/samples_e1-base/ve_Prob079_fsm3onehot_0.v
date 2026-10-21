
module TopModule (
    input wire in,
    input wire [3:0] state,
    output reg [3:0] next_state,
    output reg out
);

    
    reg [3:0] current_state;

    
    initial begin
        current_state = 4'b0001;
 
    end

    
    always @(posedge in) begin
        case (current_state)
            4'b0001: begin
                if (in == 0) begin
                    next_state = 4'b0001;
 
                    out = 0;
                end else begin
                    next_state = 4'b0010;
 
                    out = 0;
                end
            end
            4'b0010: begin
                if (in == 0) begin
                    next_state = 4'b0100;
 
                    out = 0;
                end else begin
                    next_state = 4'b0010;
 
                    out = 0;
                end
            end
            4'b0100: begin
                if (in == 0) begin
                    next_state = 4'b0001;
 
                    out = 0;
                end else begin
                    next_state = 4'b1000;
 
                    out = 1;
                end
            end
            4'b1000: begin
                if (in == 0) begin
                    next_state = 4'b0100;
 
                    out = 0;
                end else begin
                    next_state = 4'b0010;
 
                    out = 0;
                end
            end
        endcase
    end

    
    always @(posedge in) begin
        case (current_state)
            4'b0001: begin
                out = 0;
            end
            4'b0010: begin
                out = 0;
            end
            4'b0100: begin
                out = 0;
            end
            4'b1000: begin
                out = 1;
            end
        endcase
    end

endmodule
