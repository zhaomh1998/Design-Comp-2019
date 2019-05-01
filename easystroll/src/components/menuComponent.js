import React, { Component } from 'react';
import { Media } from 'reactstrap';

class Menu extends Component {

	//define constructor
	constructor(props){
		super(props); //required whenever you create a class component
	
		//define states
		this.state={
			menu_item1:[
				{
					id: 0,
					name: 'name1',
					image: 'assets/images/patient.png',
					category: 'some category' ,
					label: 'Some label ',
					price: 'some price',
					desciption: 'some desciption',
				},
				{
					id: 0,
					name: 'name2',
					image: 'assets/images/patient.png',
					category: 'some category' ,
					label: 'Some label ',
					price: 'some price',
					desciption: 'some desciption',
				},
				{
					id: 0,
					name: 'name3',
					image: 'assets/images/patient.png',
					category: 'some category' ,
					label: 'Some label ',
					price: 'some price',
					desciption: 'some desciption',
				}
			]
		}
	}

	//also required
	render(){

		const some_menu = this.state.menu_item1.map((menu_item1) => {
			return (
				<div key={menu_item1.id} className="col-qw mt-5">
					<media tag="li">
						<Media left middle>
							<Media object src={menu_item1.image} alt={menu_item1.name} />
						</Media>
						<Media body className="ml-5">
							<Media heading>{menu_item1.name}</Media>
							<p>{menu_item1.desciption} </p>
						</Media>
					</media>
				</div>
			);
		});

		return (
			<div className="container"> 
				<div className="row">
					<Media list>
						{some_menu}
					</Media>
				</div>
			</div>
		);
	}
}

//always remember to export component
export default Menu;