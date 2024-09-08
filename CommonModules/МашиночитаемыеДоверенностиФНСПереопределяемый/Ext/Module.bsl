﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2024, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// При заполнении налоговых органов действия.
// 
// Параметры:
//  Организации - Массив, Неопределено
//  НалоговыеОрганыДействия - ТаблицаЗначений
//
Процедура ПриЗаполненииНалоговыхОргановДействия(Организации, НалоговыеОрганыДействия) Экспорт
	
	//++ Локализация
	
	
	//-- Локализация
	
КонецПроцедуры

// Вызывается в форме машиночитаемой доверенности для заполнения реквизитов организации при выборе доверителя и представителя,
// если выбран вид представителя/доверителя "Организация".
// 
// Параметры:
//  Организация - ОпределяемыйТип.Организация - ссылка на организацию, реквизиты которой надо заполнить.
//  Реквизиты - Структура:
//                * ЭтоИндивидуальныйПредприниматель - Булево
//                * ЭтоИностраннаяОрганизация - Булево
//                * ЭтоФилиал - Булево
//                * НаименованиеПолное - Строка
//                * НаименованиеСокращенное - Строка
//                * ИНН - Строка
//                * КПП - Строка
//                * ОГРН - Строка
//                * ЭлектроннаяПочта - Строка
//                * ЭлектроннаяПочтаЗначение - Строка - в формате JSON, как его возвращает
//                  функция КонтактнаяИнформацияОбъекта общего модуля УправлениеКонтактнойИнформацией.
//                * Телефон - Строка
//                * ТелефонЗначение - Строка - в формате JSON, как его возвращает
//                  функция КонтактнаяИнформацияОбъекта общего модуля УправлениеКонтактнойИнформацией.
//                Заполняются для иностранной организации:
//                * НомерЗаписиОбАккредитации - Строка
//                * СтранаРегистрации - СправочникСсылка.СтраныМира
//                * СтранаРегистрацииКод - Строка
//                * РегистрационныйНомерВСтранеРегистрации - Строка
//                * НаименованиеРегистрирующегоОргана - Строка
//                * КодНалогоплательщикаВСтранеРегистрации - Строка
//                * ФактическийАдрес - Строка
//                * ФактическийАдресЗначение - Строка - в формате JSON, как его возвращает
//                  функция КонтактнаяИнформацияОбъекта общего модуля УправлениеКонтактнойИнформацией.
//                * ЮридическийАдресВСтранеРегистрации - Строка
//                * ЮридическийАдресВСтранеРегистрацииЗначение - Строка - в формате JSON, как его возвращает
//                  функция КонтактнаяИнформацияОбъекта общего модуля УправлениеКонтактнойИнформацией.
//                Заполняются для российской организации:
//                * НаименованиеУчредительногоДокумента - Строка
//                * ЮридическийАдрес - Строка
//                * ЮридическийАдресЗначение - Строка - в формате JSON, как его возвращает
//                  функция КонтактнаяИнформацияОбъекта общего модуля УправлениеКонтактнойИнформацией.
//                Заполняются для филиала:
//                * РегистрационныйНомерФилиала - Строка
//                Данные о физическом лице с правом действия без доверенности:
//                * ЛицоБезДоверенности - ОпределяемыйТип.ФизическоеЛицо
//                * РеквизитыЛицаБезДоверенности - см. ПриЗаполненииРеквизитовФизическогоЛица.Реквизиты
//
//  СтандартнаяОбработка - Булево - установите в Ложь, если нужно отменить заполнение реквизитов из подсистемы Организации
//
Процедура ПриЗаполненииРеквизитовОрганизации(Организация, Реквизиты, СтандартнаяОбработка) Экспорт
	
	
КонецПроцедуры

// Вызывается в форме машиночитаемой доверенности для заполнения реквизитов физического лица при выборе доверителя и представителя,
// если выбран вид представителя/доверителя "Физическое лицо".
// 
// Параметры:
//  ФизическоеЛицо - ОпределяемыйТип.ФизическоеЛицо - ссылка на физлицо, реквизиты которого надо заполнить.
//  Реквизиты - Структура:
//               * ЭтоИндивидуальныйПредприниматель - Булево
//               * ЭтоФизическоеЛицо - Булево
//               * ЭтоДолжностноеЛицо - Булево
//               * ДолжностьЛицаДоверителя - Строка
//               * Фамилия - Строка
//               * Имя - Строка
//               * Отчество - Строка
//               * Пол - Число - 1 - мужской, 2 - женский
//               * ИННФЛ - Строка
//               * СтраховойНомерПФР - Строка
//               * АдресРегистрации - Строка
//               * АдресРегистрацииЗначение - Строка - в формате JSON, как его возвращает
//                  функция КонтактнаяИнформацияОбъекта общего модуля УправлениеКонтактнойИнформацией.
//               * ЭлектроннаяПочта - Строка
//               * ЭлектроннаяПочтаЗначение - Строка - в формате JSON, как его возвращает
//                  функция КонтактнаяИнформацияОбъекта общего модуля УправлениеКонтактнойИнформацией.
//               * Телефон - Строка
//               * ТелефонЗначение - Строка - в формате JSON, как его возвращает
//                  функция КонтактнаяИнформацияОбъекта общего модуля УправлениеКонтактнойИнформацией.
//               * ДатаРождения - Дата
//               * ДокументВид - Строка
//               * ДокументНомер - Строка
//               * ДокументКемВыдан - Строка
//               * ДокументДатаВыдачи - Дата
//               * ДокументКодПодразделения - Строка - код подразделения в виде 999-999
//               * ДокументСрокДействия - Дата
//               * Гражданство - СправочникСсылка.СтраныМира
//               * БезГражданства - Булево
//               * МестоРождения - Строка
//               * НомерЗаписиЕдиногоРегистраНаселения - Строка
//
Процедура ПриЗаполненииРеквизитовФизическогоЛица(ФизическоеЛицо, Реквизиты) Экспорт
	
	
КонецПроцедуры

// Вызывается в форме машиночитаемой доверенности для заполнения реквизитов контрагента при выборе доверителя и представителя,
// если выбран вид представителя/доверителя "Контрагент".
// 
// Параметры:
//  Контрагент - ОпределяемыйТип.Контрагент - ссылка на контрагента, реквизиты которого надо заполнить.
//  Реквизиты - см. ПриЗаполненииРеквизитовОрганизации.Реквизиты
//
Процедура ПриЗаполненииРеквизитовКонтрагента(Контрагент, Реквизиты) Экспорт
	
	
КонецПроцедуры

// Для выполнения прикладной проверки подписи по доверенности. Например, проверка соответствия реквизитов доверителя
// контрагенту, указанному в документе, и полномочий подписанта. Результаты проверки сохраняются в информационной базе.
//
// Параметры:
//  ДанныеДоверенности - Структура, ВыборкаИзРезультатаЗапроса:
//   * Ссылка - СправочникСсылка.МашиночитаемыеДоверенности
//   * ПодписанныйОбъект - ОпределяемыйТип.ПодписанныйОбъект - ссылка на подписанный объект.
//   * Полномочия - ТаблицаЗначений,  РезультатЗапроса - содержит реквизиты табличной части Полномочия справочника МашиночитаемыеДоверенности.
//   * Ограничения - ТаблицаЗначений, РезультатЗапроса - содержит реквизиты табличной части Ограничения справочника МашиночитаемыеДоверенности.
//  Сертификат - см. МашиночитаемыеДоверенностиФНС.ОтборДляДоверенностейПоСертификату.Сертификат
//  ПротоколПроверки - Соответствие из КлючИЗначение:
//   * Ключ - Строка - ключ проверки, для проверки полномочий и документа в протокол добавлены значения
//     с ключами "ПроверкаПолномочий" и "ПроверкаДокумента".
//   * Значение - см. МашиночитаемыеДоверенностиФНС.РезультатПроверкиДляПротокола
//
Процедура ПриПроверкеДоверенностиПодписи(ДанныеДоверенности, Сертификат, ПротоколПроверки) Экспорт
	
	
	
КонецПроцедуры

// Переопределяет описание состояния доверенности в реестре Федеральной таможенной службы или другом.
// 
// Параметры:
//  Доверенность - СправочникСсылка.МашиночитаемыеДоверенности
//  РегистрацияВРеестре - Структура:
//   * ПоказыватьРегистрироватьВРеестре - Булево - показывать флажок регистрации в реестре.
//   * ЗаголовокФлажкаРегистрации - Строка - заголовок флажка регистрации в реестре.
//   * ПодсказкаРегистрации - Строка - подсказка флажка регистрации.
//   * ЗарегистрированаВРеестре - Булево
//   * СостояниеРегистрации - Строка, ФорматированнаяСтрока
//   * ПодсказкаСостояния - Строка - подсказка состояния регистрации. 
//   * Картинка - Строка - имя картинки статуса в строке состояния.
//   * ПолномочияПриОткрытии - Неопределено, Массив из Строка - список кодов полномочий, переданных в параметре при открытии
//     формы. Можно анализировать и не отображать флажок регистрации, если полномочия относятся к другой подсистеме.
//   * ВыбранныеПолномочия - Структура:
//     ** Полномочия -  ТаблицаЗначений
//     ** Ограничения - ТаблицаЗначений
//   * КодыПолномочийДляДобавления - Массив из Строка - коды полномочий, которые предлагать добавить при выборе флажка регистрации.
//     Если одно из них уже выбрано, предложение о добавлении не выводится.
//
Процедура ПриПолученииСтатусаРегистрации(Доверенность, РегистрацияВРеестре) Экспорт
	
	//++ Локализация
	
	
	//-- Локализация
	
КонецПроцедуры

// Переопределяет процедуру регистрации в реестре Федеральной таможенной службы или другом.
// 
// Параметры:
//  Доверенность - СправочникСсылка.МашиночитаемыеДоверенности
//
Процедура ПриРегистрацииДоверенности(Доверенность) Экспорт
	
	//++ Локализация
	
	
	//-- Локализация
	
КонецПроцедуры

// Переопределяет процедуру настроек формы списка для реестра Федеральной таможенной службы или другого.
// 
// Параметры:
//  Настройки - Структура:
//   * ПоказыватьСтатусВФормеСписка - Булево - показывать статус в реестре в форме списка.
//   * ЗаголовокКолонкиСтатуса      - Строка - заголовок колонки статуса в форме списка.
//   * КартинкаКолонкиСтатуса       - Картинка - картинка колонки статуса в форме списка.
//   * КоллекцияКартинокДляСтроки   - Картинка - коллекция для картинки строки.
//
Процедура ПриОпределенииНастроек(Настройки) Экспорт
	
	//++ Локализация
	
	
	//-- Локализация
	
КонецПроцедуры

// Переопределяет процедуру получения статусов доверенностей для реестра Федеральной таможенной службы или другого.
// 
// Параметры:
//  Доверенности - Массив из СправочникСсылка.МашиночитаемыеДоверенности
//  Статусы - Соответствие из КлючИЗначение:
//   * Ключ     - СправочникСсылка.МашиночитаемыеДоверенности
//   * Значение - Структура:
//                 ** ИндексКартинки - Число - картинка колонки статуса в форме списка.
//                 ** Статус         - Строка
//
Процедура ПриПолученииСтатусов(Доверенности, Статусы) Экспорт
	
	//++ Локализация
	
	
	//-- Локализация
	
КонецПроцедуры

#КонецОбласти
