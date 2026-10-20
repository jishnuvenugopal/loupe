
module TopModule (
    input  wire clk,
    input  wire reset,
    input  wire data,
    input  wire done_counting,
    input  wire ack,
    output reg  shift_ena,
    output reg  counting,
    output reg  done
);

    
    reg [3:0] data_reg;
    reg [3:0] count;
    reg       state;
    reg       counting_reg;

    
    localparam IDLE   = 4'd0;
    localparam SEARCH = 4'd1;
    localparam SHIFT  = 4'd2;
    localparam COUNT  = 4'd3;
    localparam DONE   = 4'd4;

    
    always @(posedge clk) begin
        if (reset) begin
            data_reg <= 4'd0;
        end else begin
            data_reg <= {data_reg[2:0], data};
        end
    end

    
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
        end else begin
            case (state)
                IDLE: begin
                    if (data_reg == 4'd1101) begin
                        state <= SEARCH;
                    end else begin
                        state <= IDLE;
                    end
                end
                SEARCH: begin
                    if (count == 3'd3) begin
                        state <= SHIFT;
                    end else begin
                        state <= SEARCH;
                    end
                end
                SHIFT: begin
                    if (count == 3'd3) begin
                        state <= COUNT;
                    end else begin
                        state <= SHIFT;
                    end
                end
                COUNT: begin
                    if (done_counting) begin
                        state <= DONE;
                    end else begin
                        state <= COUNT;
                    end
                end
                DONE: begin
                    if (ack) begin
                        state <= IDLE;
                    end else begin
                        state <= DONE;
                    end
                end
                default: state <= IDLE;
            endcase
        end
    end

    
    always @(posedge clk) begin
        if (reset) begin
            shift_ena <= 1'b0;
        end else begin
            if (state == SHIFT) begin
                if (count == 3'd3) begin
                    shift_ena <= 1'b0;
                end else begin
                    shift_ena <= 1'b1;
                    count <= count + 1'b1;
                end
            end else begin
                shift_ena <= 1'b0;
            end
        end
    end

    
    always @(posedge clk) begin
        if (reset) begin
            counting_reg <= 1'b0;
        end else begin
            if (state == COUNT) begin
                counting_reg <= 1'b1;
            end else begin
                counting_reg <= 1'b0;
            end
        end
    end
    assign counting = counting_reg;

    
    always @(posedge clk) begin
        if (reset) begin
            done <= 1'b0;
        end else begin
            if (state == DONE) begin
                done <= 1'b1;
            end else begin
                done <= 1'b0;
            end
        end
    end

endmodule
