
module TopModule (
    input  wire clk,
    input  wire reset,
    input  wire data,
    output reg  [3:0] count,
    output reg        counting,
    output reg        done,
    input  wire       ack
);

    
    reg [3:0] delay;
    reg       state;
    reg       start_search;
    reg       found_start;
    reg       shift_delay;
    reg       counting_active;
    reg       done_active;

    
    
    parameter IDLE    = 4'd0;
    parameter START   = 4'd1;
    parameter COUNT   = 4'd2;
    parameter DONE    = 4'd3;

    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state        <= IDLE;
            found_start  <= 1'b0;
            shift_delay  <= 1'b0;
            count        <= 4'd0;
            delay        <= 4'd0;
            start_search <= 1'b0;
            counting     <= 1'b0;
            done         <= 1'b0;
        end else begin
            case (state)
                IDLE: begin
                    if (data == 4'b1101) begin
                        state        <= START;
                        found_start  <= 1'b1;
                        shift_delay  <= 1'b0;
                        count        <= 4'd0;
                        delay        <= 4'd0;
                        start_search <= 1'b1;
                        counting     <= 1'b0;
                        done         <= 1'b0;
                    end else begin
                        state        <= IDLE;
                        found_start  <= 1'b0;
                        shift_delay  <= 1'b0;
                        count        <= 4'd0;
                        delay        <= 4'd0;
                        start_search <= 1'b0;
                        counting     <= 1'b0;
                        done         <= 1'b0;
                    end
                end
                START: begin
                    if (shift_delay) begin
                        state        <= COUNT;
                        found_start  <= 1'b0;
                        shift_delay  <= 1'b0;
                        count        <= delay;
                        delay        <= 4'd0;
                        start_search <= 1'b0;
                        counting     <= 1'b1;
                        done         <= 1'b0;
                    end else begin
                        state        <= START;
                        found_start  <= 1'b0;
                        shift_delay  <= 1'b1;
                        count        <= 4'd0;
                        delay        <= 4'd0;
                        start_search <= 1'b0;
                        counting     <= 1'b0;
                        done         <= 1'b0;
                    end
                end
                COUNT: begin
                    if (count == 4'd0) begin
                        state        <= DONE;
                        found_start  <= 1'b0;
                        shift_delay  <= 1'b0;
                        count        <= 4'd0;
                        delay        <= 4'd0;
                        start_search <= 1'b0;
                        counting     <= 1'b0;
                        done         <= 1'b1;
                    end else begin
                        state        <= COUNT;
                        found_start  <= 1'b0;
                        shift_delay  <= 1'b0;
                        count        <= count - 1'b1;
                        delay        <= 4'd0;
                        start_search <= 1'b0;
                        counting     <= 1'b1;
                        done         <= 1'b0;
                    end
                end
                DONE: begin
                    if (ack) begin
                        state        <= IDLE;
                        found_start  <= 1'b0;
                        shift_delay  <= 1'b0;
                        count        <= 4'd0;
                        delay        <= 4'd0;
                        start_search <= 1'b0;
                        counting     <= 1'b0;
                        done         <= 1'b0;
                    end else begin
                        state        <= DONE;
                        found_start  <= 1'b0;
                        shift_delay  <= 1'b0;
                        count        <= 4'd0;
                        delay        <= 4'd0;
                        start_search <= 1'b0;
                        counting     <= 1'b0;
                        done         <= 1'b1;
                    end
                end
                default: begin
                    state        <= IDLE;
                    found_start  <= 1'b0;
                    shift_delay  <= 1'b0;
                    count        <= 4'd0;
                    delay        <= 4'd0;
                    start_search <= 1'b0;
                    counting     <= 1'b0;
                    done         <= 1'b0;
                end
            endcase
        end
    end

    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            delay <= 4'd0;
        end else begin
            if (shift_delay) begin
                delay <= {delay[2:0], data};
                shift_delay <= 1'b0;
            end
        end
    end

    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            count <= 4'd0;
        end else begin
            if (counting_active) begin
                count <= count - 1'b1;
            end
        end
    end

    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            done <= 1'b0;
        end else begin
            if (done_active) begin
                done <= 1'b1;
            end
        end
    end

    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            counting <= 1'b0;
        end else begin
            if (state == COUNT) begin
                counting <= 1'b1;
            end else begin
                counting <= 1'b0;
            end
        end
    end

    
    always @(posedge clk or posedge reset) begin
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
