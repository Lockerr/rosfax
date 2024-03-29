# language: ru
@javascript
Функционал: Управление шедулями
  Предыстория:
    Допустим я создал компанию
    Допустим есть пользователь
    Допустим пользователь принадлежит этой компании
    Допустим я создал schedule на завтра для этой компании

  Сценарий: получение уведомлений на почту
    То администраторы компании должны получить письма

  Сценарий: Отображение списка шедуль
    Пусть я залогинился
    И у пользователя должна быть компания
    Если я зайду на '/schedules'
    То я должен увидеть 'Антон'
        И я должен увидеть 'Уах'
        И я должен увидеть '+7 908 815 51 07'
    Если я нажму на '#edit_schedule'
    И я должен увидеть 'Эта'
    И шедуля не верифицирована

  Сценарий: Верификация шедулей
    Пусть я залогинился
    Если я зайду на '/schedules'
    Если я нажму на '#confirm'
    То шедуля должна быть верифицирована

  Сценарий: Измениение времени шедули
    Пусть я залогинился
    Если я зайду на '/schedules'
    Если я нажму на '#edit_schedule'
    То я должен увидеть 'Управление осмотром'
    Если я нажму на '#move_schedule'
    То элемент '#move_schedule' должен иметь класс 'active'
    Если я нажму на '.free'
    То шедуля должна изменить время
    То на месте шедули должно отображаться свободное место

  Сценарий: Блокирование времени
    Пусть я залогинился
    Если я зайду на '/schedules'
    Если я нажму на '#edit_schedule'
    Если я нажму '#schedule_block'
    Если я нажму на '.free'
    То я должен увидеть 'Нет приема'
