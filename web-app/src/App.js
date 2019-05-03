import React, { Component } from 'react';
import './App.css';
import { Navbar, NavbarBrand } from 'reactstrap';
import List from './myComponents/my_list';
import { MY_PARTS } from './shared/parts';

class App extends Component {

  //define state
  constructor(props){
    super(props);

    this.state = {
      parts: MY_PARTS
    };
  }

  render(){
    return (
      <div className="App">
        <Navbar dark color="primary">
          <div className="container">
            <NavbarBrand href="/"> Easy Stroll </NavbarBrand>
          </div>
        </Navbar>
        <List parts={this.state.parts}/>
      </div>
      );
  }
}

export default App;
