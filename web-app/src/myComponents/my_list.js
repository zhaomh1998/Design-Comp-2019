import React, {Component} from 'react';
import { Media } from 'reactstrap';


//add a new component
class List extends Component{

	//define constructor
	constructor(props){
		//required for any new component
		super(props);

		//initialize the state of the compo
		this.state = {
			my_parts: [
				{
                	number: 0,
                	name:'Arduino',
                	image: 'assets/imgs/arduino.jpg',
                	price:'20.00',
                	description:'Microcontroller in charge'
                },
                {
                	number: 1,
                	name:'TFmini LiDAR',
                	image: 'assets/imgs/tfmini.jpg',
                	price:'40.00',
                	description:'LiDAR for scanning the front of the walker'
                },
                {
                	number: 2,
                	name:'Servo motor',
                	image: 'assets/imgs/servo.jpg',
                	price:'5.00',
                	description:'servo to rotate the tfmini lidar'
                },
                {
                	number: 3,
                	name:'IoT shield',
                	image: 'assets/imgs/iotshield.jpg',
                	price:'75.00',
                	description:'GPS + LTE + Internet'
                }
			],
		};
	}

	//define render method
	render(){
	
		// const parts = test.map((my_parts) => {
		const parts = this.props.parts.map((my_parts) => {

			return(
				<div key={my_parts.number} className="col-12 mt=5">
					<Media tag="li">
						<Media left middle>
							<Media object src={my_parts.image} alt={my_parts.name} height="100"/>
						</Media>
						<Media body className="ml-5">
							<Media heading>{my_parts.name}</Media>
							<p>{my_parts.description}</p>
						</Media>
					</Media>
				</div>
			);
		});

		return (
			<div className="container">
				<div className="row">	
					<Media list>
						{parts}
					</Media>
				</div>
			</div>
		);
	}
}

export default List;