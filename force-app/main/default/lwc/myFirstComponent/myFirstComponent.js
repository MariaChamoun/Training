import { LightningElement } from 'lwc';

export default class MyFirstComponent extends LightningElement {
    x = 10;
    messageparent="Hello from parent";
    handleClick(){
        alert ("Hello:" + this.x);
    }
}