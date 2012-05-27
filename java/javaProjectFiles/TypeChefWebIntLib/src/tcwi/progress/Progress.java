package tcwi.progress;

public class Progress {
	private int currentStatus;		//The current tick status
	private int maxTicks;			//Maximal ticks
	private int tickSize;			//Size per tick in percent
	private double border;			//A border needed for tick
	private int tick;				//Tick step-size
	
	public Progress(int tickSize, int maxTicks){
		this.tickSize = tickSize;
		if(tickSize>100)
			this.tickSize = 100;
		this.currentStatus = 0;
		this.maxTicks = maxTicks;
		this.tick = this.maxTicks/this.tickSize;
		this.border = 0;
	}
	
	/**
	 * This function count up <tt>this.currentStatus</tt> and check if it reach a calculated
	 * barrier. If it does, it gives out the right progess in percent out
	 * @return
	 */
	public double tick(){
		if(this.currentStatus<=this.maxTicks){ //It prohibits more ticks than there is
			if(this.currentStatus==0){ //Needed for 0%
				this.currentStatus++;
				return 0;
			}
			if(this.currentStatus>=this.maxTicks-1){ //Needed for 100%
				return 100;
			}
			
			for(int i=1;i<=tick;i++){
				if(this.currentStatus>=tickSize*i&&border==tickSize*(i-1)){
					border=tickSize*i;
					double calc = ((double)this.currentStatus/maxTicks)*100;
					this.currentStatus++;
					return calc;
				}
			}
			this.currentStatus++;
		}
		return -1.0;
	}	
	
	/**
	 * This function calls <tt>tick()</tt> and print out the status in the console
	 */
	public void tickAndPrint(){
		double t = tick();
		if(t!=-1.0){
			char c = 37;
			System.out.printf("%.0f%s...",t,c);
		}
	}
	
	/**
	 * Reset the progress
	 */
	public void reset(){
		this.currentStatus = 0;
		this.border = 0;
	}
	
	public void addMaxTicks(int maxTicks){
		this.maxTicks += maxTicks;
		this.tick = this.maxTicks/this.tickSize;
	}

}
