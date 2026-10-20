
module TopModule (
    input  wire clk,
    input  wire reset,
    input  wire in,
    output reg  done
);

    
    localparam IDLE = 3'd0;
    localparam DATA = 3'd1;
    localparam STOP = 3'd2;

    
    reg [2:0] state;
    reg [8:0] data_reg;
    reg [2:0] bit_count;
    reg [1:0] stop_count;

    
    reg done_reg;

    
    always @(posedge clk) begin
        if (reset)
            state <= IDLE;
        else
            state <= next_state;
    end

    
    reg [2:0] next_state;
    always @(*) begin
        case (state)
            IDLE: begin
                if (in == 1'b0) 
                    next_state = DATA;
                else
                    next_state = IDLE;
            end
            DATA: begin
                if (bit_count == 8'd8) 
                    next_state = STOP;
                else
                    next_state = DATA;
            end
            STOP: begin
                if (in == 1'b1) 
                    next_state = IDLE;
                else
                    next_state = STOP;
            end
            default: next_state = IDLE;
        endcase
    end

    
    always @(posedge clk) begin
        case (state)
            DATA: begin
                data_reg[bit_count] <= in;
                bit_count <= bit_count + 1'b1;
            end
            STOP: begin
                if (in == 1'b1) 
                    stop_count <= stop_count + 1'b1;
                else
                    stop_count <= 2'b00;
            end
            default: begin
                data_reg <= 9'b0;
                bit_count <= 3'b000;
                stop_count <= 2'b00;
            end
        endcase
    end

    
    always @(*) begin
        case (state)
            IDLE: begin
                if (bit_count == 8'd8) 
                    done_reg = 1'b1;
                else
                    done_reg = 1'b0;
            end
            STOP: begin
                if (stop_count == 2'b01) 
                    done_reg = 1'b1;
                else
                    done_reg = 1'b0;
            end
            default: done_reg = 1'b0;
        endcase
    end

    assign done = done_reg;

endmodule
