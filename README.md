# Tarantool front-end boilerplate

**TODO:**

* add redux-saga
* правильная работа с асетами
* ваши любимые плагины
* lazy-fetching

## Guideleine:

Components должны быть как можно более инкапсулированными. От типизации как контейнеров и других видов компонентов, которые все еще компоненты стоит отказаться. Если хочеться переиспользовать какую-то логику выборки, то выносить не в контейнеры эту логику а в selectors. Втащите в компоненты все нужное для отображения. То есть если нужно использовать картинки ложите их внутрь компонента Component/assets/. Сама структура `Component/index.js` в нем лежит `export default class Component` или `export default () => ()`, т.е. корневой компонент. Стили можно писать 2мя валидными способами, использование stylus с Component/index.styl, либо используя emotion/react-emotion. В случае использование stylus нужно придерживаться классический БЭМ-нотации. block__element_modifier. В случае использование emotion нужно экспортировать помимо корневого компонента еще библиотеку стилей компонента. У emotion есть 3 стиля записи: styled-components, css, css-object-notation. Для первого стиля просто экспортировать Под-компоненты. Для второго и третьего стиля создавать отдельный объект библиотеку стилей компонента и ее экспортировать: ```export const styles = { component: css`display: flex` }```. Если есть под-компоненты то создавать либо внутри корневого файла либо внутри папки.

Не грешно заводить утилитную стилистическую библиотеку. И делать компонент, который является на самом деле набором стилистических компонентов. Как минимум для удобного роутинга.

Selectors селекторы выносим в отдельный файл/директорию внутри store. Они зачастую работуют на стыке стора и проперти и поэтому там им самое место. С actions также.

По роутингу. Вынести все определение урлов и их генерацию в отдельный утилитный файл. И пользоваться им в последствие для этих задач. В данном бандле уже есть связь с redux роутером. Хорошим стилем будет являться, очищение не нужных вам стейтов при смене страницы.

По стейту. Предлагаю наоброт идти к тому что redux-first. И только если проект разрастается идти в сторону. Понятно, что совсем локальные состояния не стоит пихать, но и экономить state не стоит. Дает большее понимание что происходит и проще работать с этой историей и тестировать ее.

`npm run fix` - поправить все, что можно с prettier/eslint.
`npm run lint` - посмотреть на все, что ноет линтеры.
`npm run flow` - посмотреть на все, что ноет flow.