import { LightningElement } from 'lwc';

export default class UserProfileCard extends LightningElement {
    user1 ={
        name: 'User1Name',
        title: 'User1JobTitle',
        email: 'User1Email',
        status: 'Online' 
    }
    user2={
        name: 'User2Name',
        title: 'User2JobTitle',
        email: 'User2Email',
        status: 'Online'
    }
    currentUser={... this.user1};
    switchusers(){
        this.currentUser = this.currentUser.name === this.user1.name ? {...this.user2} : {...this.user1};
    }
    userstatus(){
        
        
    }
}