import UsersView from '../'
import UsersSearch from '../_components/UsersSearch'
import UserView from '../_components/UserView'

const route = {
  path: '/users',
  name: 'users',
  redirect: '/users/search',
  component: UsersView,
  meta: { transitionDelay: 300 * 2 }, // See _transitions.scss => $slide-bottom-duration
  children: [
    {
      path: 'search',
      component: UsersSearch
    },
    {
      path: '/user/:pid',
      name: 'user',
      component: UserView,
      props: true
    }
  ]
}

export default route
