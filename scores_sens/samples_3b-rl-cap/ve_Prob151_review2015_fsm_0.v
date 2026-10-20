
module TopModule (
    input        clk,
    input        reset,
    input        data,
    input        done_counting,
    input        ack,
    output reg   shift_ena,
    output reg   counting,
    output reg   done
);

    
    reg [3:0] pattern;
     
    reg [30:0] count;
      
    reg [2:0] state;
       

    
    localparam IDLE = 3'd0;
    localparam SHIFT = 3'd1;
    localparam COUNTING = 3'd2;
    localparam DONE = 3'd3;

    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            pattern <= 4'b0000;
            count <= 31'd0;
            shift_ena <= 1'b0;
            counting <= 1'b0;
            done <= 1'b0;
        end else begin
            case (state)
                IDLE: begin
                    if (data == 4'b1101) begin
                        state <= SHIFT;
                        pattern <= 4'b1101;
                        count <= 31'd0;
                    end
                    else begin
                        state <= IDLE;
                    end
                end
                SHIFT: begin
                    if (count == 31'd3) begin
                        state <= COUNTING;
                        count <= 31'd0;
                        shift_ena <= 1'b0;
                    end else begin
                        pattern <= {pattern[2:0], data};
                        count <= count + 1'b1;
                        shift_ena <= 1'b1;
                    end
                end
                COUNTING: begin
                    if (done_counting) begin
                        state <= DONE;
                        shift_ena <= 1'b0;
                        counting <= 1'b1;
                    end else begin
                        state <= COUNTING;
                        shift_ena <= 1'b0;
                    end
                end
                DONE: begin
                    if (ack) begin
                        state <= IDLE;
                        shift_ena <= 1'b0;
                        counting <= 1'b0;
                        done <= 1'b0;
                    end else begin
                        state <= DONE;
                        shift_ena <= 1'b0;
                    end
                end
                default: state <= IDLE;
            endcase
        end
    end

endmodule
