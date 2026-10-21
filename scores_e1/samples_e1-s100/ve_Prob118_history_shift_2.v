
module TopModule (
    input clk,
    input areset,
    input predict_valid,
    input predict_taken,
    input train_mispredicted,
    input train_taken,
    input train_history   (32 bits),
    output predict_history (32 bits)
);

    
    reg [31:0] history;

    
    reg [5:0] history_counter;

    
    reg pipeline_flush;

    
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            history <= 32'b0;
            history_counter <= 6'b0;
            pipeline_flush <= 0;
        end else begin
            
            history_counter <= history_counter + 1'b1;

            
            if (predict_valid) begin
                history <= history_counter << 1 | predict_taken;
            end else if (train_mispredicted) begin
                history <= train_history << 1 | train_taken;
            end else if (pipeline_flush) begin
                history <= 32'b0;
                history_counter <= 6'b0;
            end
        end
    end

    
    assign predict_history = history;

endmodule
